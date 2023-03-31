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
    [Route("api/lecturer")]
    [ApiController]
    public class LecturerController : ControllerBase
    {
        private readonly ILecturer _ILecturer;

        public LecturerController(ILecturer ILecturer)
        {
            _ILecturer = ILecturer;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Lecturer>>> Get()
        {
            return Ok(await Task.FromResult(_ILecturer.GetLecturers()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Lecturer>> Get(int id)
        {
            var lecturer = await Task.FromResult(_ILecturer.GetLecturer(id));
            if (lecturer == null)
            {
                return NotFound();
            }
            return Ok(lecturer);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Lecturer>> Post(Lecturer lecturer)
        {
            _ILecturer.AddLecturer(lecturer);
            return Ok(await Task.FromResult(lecturer));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Lecturer>> Put(int id, Lecturer lecturer)
        {
            if (id != lecturer.LecturerID)
            {
                return BadRequest();
            }
            try
            {
                _ILecturer.UpdateLecturer(lecturer);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LecturerExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(lecturer));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Lecturer>> Delete(int id)
        {
            var lecture = _ILecturer.DeleteLecturer(id);
            return Ok(await Task.FromResult(lecture));
        }

        private bool LecturerExists(int id)
        {
            return _ILecturer.CheckLecturer(id);
        }
    }
}
