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
    [Route("api/admin")]
    [ApiController]
    public class AdminController : ControllerBase
    {
        private readonly IAdmin _IAdmin;

        public AdminController(IAdmin IAdmin)
        {
            _IAdmin = IAdmin;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Admin>>> Get()
        {
            return Ok(await Task.FromResult(_IAdmin.GetAdmins()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Admin>> Get(int id)
        {
            var admin = await Task.FromResult(_IAdmin.GetAdmin(id));
            if (admin == null)
            {
                return NotFound();
            }
            return Ok(admin);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Admin>> Post(Admin admin)
        {
            _IAdmin.AddAdmin(admin);
            return Ok(await Task.FromResult(admin));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Admin>> Put(int id, Admin admin)
        {
            if (id != admin.AdminID)
            {
                return BadRequest();
            }
            try
            {
                _IAdmin.UpdateAdmin(admin);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!AdminExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(admin));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Admin>> Delete(int id)
        {
            var admin = _IAdmin.DeleteAdmin(id);
            return Ok(await Task.FromResult(admin));
        }

        private bool AdminExists(int id)
        {
            return _IAdmin.CheckAdmin(id);
        }
    }
}
