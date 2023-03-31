<<<<<<< Updated upstream
﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace RESTful_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CourseController : ControllerBase
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
    [Route("api/course")]
    [ApiController]
    public class CourseController : ControllerBase
    {
        private readonly ICourse _ICourse;

        public CourseController(ICourse ICourse)
        {
            _ICourse = ICourse;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Course>>> Get()
        {
            return Ok(await Task.FromResult(_ICourse.GetCourses()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Course>> Get(int id)
        {
            var course = await Task.FromResult(_ICourse.GetCourse(id));
            if (course == null)
            {
                return NotFound();
            }
            return Ok(course);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Course>> Post(Course course)
        {
            _ICourse.AddCourse(course);
            return Ok(await Task.FromResult(course));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Course>> Put(int id, Course course)
        {
            if (id != course.CourseID)
            {
                return BadRequest();
            }
            try
            {
                _ICourse.UpdateCourse(course);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!CourseExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(course));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Course>> Delete(int id)
        {
            var course = _ICourse.DeleteCourse(id);
            return Ok(await Task.FromResult(course));
        }

        private bool CourseExists(int id)
        {
            return _ICourse.CheckCourse(id);
        }
>>>>>>> Stashed changes
    }
}
