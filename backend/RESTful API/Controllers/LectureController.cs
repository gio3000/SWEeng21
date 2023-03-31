<<<<<<< Updated upstream
﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace RESTful_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LectureController : ControllerBase
    {
=======
﻿using Microsoft.AspNetCore.Authorization;
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
    [Route("api/lecture")]
    [ApiController]
    public class LectureController : ControllerBase
    {
        private readonly ILecture _ILecture;

        public LectureController(ILecture ILecture)
        {
            _ILecture = ILecture;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Lecture>>> Get()
        {
            return Ok(await Task.FromResult(_ILecture.GetLectures()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Lecture>> Get(int id)
        {
            var lecture = await Task.FromResult(_ILecture.GetLecture(id));
            if (lecture == null)
            {
                return NotFound();
            }
            return Ok(lecture);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Lecture>> Post(Lecture lecture)
        {
            _ILecture.AddLecture(lecture);
            return Ok(await Task.FromResult(lecture));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Lecture>> Put(int id, Lecture lecture)
        {
            if (id != lecture.LectureID)
            {
                return BadRequest();
            }
            try
            {
                _ILecture.UpdateLecture(lecture);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!LectureExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(lecture));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Lecture>> Delete(int id)
        {
            var lecture = _ILecture.DeleteLecture(id);
            return Ok(await Task.FromResult(lecture));
        }

        private bool LectureExists(int id)
        {
            return _ILecture.CheckLecture(id);
        }
>>>>>>> Stashed changes
    }
}
