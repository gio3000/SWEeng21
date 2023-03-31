<<<<<<< Updated upstream
﻿using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace RESTful_API.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class StudentController : ControllerBase
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
    [Route("api/student")]
    [ApiController]
    public class StudentController : ControllerBase
    {
        private readonly IStudent _IStudent;

        public StudentController(IStudent IStudent)
        {
            _IStudent = IStudent;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Student>>> Get()
        {
            return Ok(await Task.FromResult(_IStudent.GetStudents()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Student>> Get(int id)
        {
            var student = await Task.FromResult(_IStudent.GetStudent(id));
            if (student == null)
            {
                return NotFound();
            }
            return Ok(student);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Student>> Post(Student student)
        {
            _IStudent.AddStudent(student);
            return Ok(await Task.FromResult(student));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Student>> Put(int id, Student student)
        {
            if (id != student.StudentID)
            {
                return BadRequest();
            }
            try
            {
                _IStudent.UpdateStudent(student);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!StudentExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(student));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Student>> Delete(int id)
        {
            var student = _IStudent.DeleteStudent(id);
            return Ok(await Task.FromResult(student));
        }

        private bool StudentExists(int id)
        {
            return _IStudent.CheckStudent(id);
        }
>>>>>>> Stashed changes
    }
}
