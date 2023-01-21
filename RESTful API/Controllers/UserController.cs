using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Controllers
{
    [Authorize]
    [Route("api/user")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly IUsers _IUser;

        public UserController(IUsers IUser)
        {
            _IUser = IUser;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> Get()
        {
            return Ok(await Task.FromResult(_IUser.GetUsers()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<User>> Get(int id)
        {
            var employees = await Task.FromResult(_IUser.GetUser(id));
            if (employees == null)
            {
                return NotFound();
            }
            return Ok(employees);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<User>> Post(User user)
        {
            _IUser.AddUser(user);
            return Ok(await Task.FromResult(user));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<User>> Put(int id, User user)
        {
            if (id != user.UserID)
            {
                return BadRequest();
            }
            try
            {
                _IUser.UpdateUser(user);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!UserExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(user));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<User>> Delete(int id)
        {
            var employee = _IUser.DeleteUser(id);
            return Ok(await Task.FromResult(employee));
        }

        private bool UserExists(int id)
        {
            return _IUser.CheckUser(id);
        }
    }
}
