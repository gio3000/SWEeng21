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
    [Route("api/module")]
    [ApiController]
    public class ModuleController : ControllerBase
    {
        private readonly IModule _IModule;

        public ModuleController(IModule IModule)
        {
            _IModule = IModule;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Module>>> Get()
        {
            return Ok(await Task.FromResult(_IModule.GetModules()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Module>> Get(int id)
        {
            var module = await Task.FromResult(_IModule.GetModule(id));
            if (module == null)
            {
                return NotFound();
            }
            return Ok(module);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Module>> Post(Module module)
        {
            _IModule.AddModule(module);
            return Ok(await Task.FromResult(module));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Module>> Put(int id, Module module)
        {
            if (id != module.ModuleID)
            {
                return BadRequest();
            }
            try
            {
                _IModule.UpdateModule(module);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ModuleExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(module));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Module>> Delete(int id)
        {
            var lecture = _IModule.DeleteModule(id);
            return Ok(await Task.FromResult(lecture));
        }

        private bool ModuleExists(int id)
        {
            return _IModule.CheckModule(id);
        }
    }
}
