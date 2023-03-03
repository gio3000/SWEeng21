using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Controllers
{
    [Route("api/exam")]
    [ApiController]
    public class ExamController : ControllerBase
    {
        private readonly IExam _IExam;

        public ExamController(IExam IExam)
        {
            _IExam = IExam;
        }

        // GET: api/user>
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Exam>>> Get()
        {
            return Ok(await Task.FromResult(_IExam.GetExams()));
        }

        // GET api/user/5
        [HttpGet("{id}")]
        public async Task<ActionResult<Exam>> Get(int id)
        {
            var exam = await Task.FromResult(_IExam.GetExam(id));
            if (exam == null)
            {
                return NotFound();
            }
            return Ok(exam);
        }

        // POST api/user
        [HttpPost]
        public async Task<ActionResult<Exam>> Post(Exam exam)
        {
            _IExam.AddExam(exam);
            return Ok(await Task.FromResult(exam));
        }

        // PUT api/user/5
        [HttpPut("{id}")]
        public async Task<ActionResult<Exam>> Put(int id, Exam exam)
        {
            if (id != exam.ExamID)
            {
                return BadRequest();
            }
            try
            {
                _IExam.UpdateExam(exam);
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ExamExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }
            return Ok(await Task.FromResult(exam));
        }

        // DELETE api/user/5
        [HttpDelete("{id}")]
        public async Task<ActionResult<Exam>> Delete(int id)
        {
            var exam = _IExam.DeleteExam(id);
            return Ok(await Task.FromResult(exam));
        }

        private bool ExamExists(int id)
        {
            return _IExam.CheckExam(id);
        }
    }
}
