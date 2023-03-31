using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Controllers
{
    [EnableCors("MyPolicy")]
    [Authorize]
    [Route("api/secretary")]
    [ApiController]
    public class SecretaryController : ControllerBase
    {
        private readonly ISecretary _ISecretary;

        public SecretaryController(ISecretary ISecretary)
        {
            _ISecretary = ISecretary;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Secretary>>> Get()
        {
            return Ok(await Task.FromResult(_ISecretary.GetSecretaries()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Secretary>> Get(int id)
        {
            var secretary = await Task.FromResult(_ISecretary.GetSecretary(id));
            if (secretary == null)
            {
                return NotFound();
            }
            return Ok(secretary);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Secretary>> Post(Secretary secretary)
        {
            _ISecretary.AddSecretary(secretary);
            return Ok(await Task.FromResult(secretary));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Secretary>> Put(int id, Secretary secretary)
        {
            if (id !=   secretary.SecretaryID)
            {
                return BadRequest();
            }
            try
            {
                _ISecretary.UpdateSecretary(secretary);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!SecretaryExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(secretary));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Secretary>> Delete(int id)
        {
            var secretary = _ISecretary.DeleteSecretary(id);
            return Ok(await Task.FromResult(secretary));
        }

        private bool SecretaryExists(int id)
        {
            return _ISecretary.CheckSecretary(id);
        }
    }
}
