using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class ExamRepository : IExam
    {
        readonly DatabaseContext _dbContext = new();

        public ExamRepository(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void AddExam(Exam exam)
        {
            try
            {
                _dbContext.Exams.Add(exam);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckExam(int id)
        {
            return _dbContext.Exams.Any(e => e.ExamID == id);
        }

        public Exam DeleteExam(int id)
        {
            try
            {
                Exam? exam = _dbContext.Exams.Single(e => e.ExamID == id);

                if (exam != null)
                {
                    _dbContext.Exams.Remove(exam);
                    _dbContext.SaveChanges();
                    return exam;
                }
                else
                {
                    throw new ArgumentNullException();
                }
            }
            catch
            {
                throw;
            }
        }

        public Exam GetExam(int id)
        {
            try
            {
                Exam? course = _dbContext.Exams
                    .Include(s => s.StudentID)
                    .Include(l => l.LectureID)
                    .Single(e => e.ExamID == id);
                if (course != null)
                {
                    return course;
                }
                else
                {
                    throw new ArgumentNullException();
                }
            }
            catch
            {
                throw;
            }
        }

        public List<Exam> GetExams()
        {
            try
            {
                return _dbContext.Exams                    
                    .Include(s => s.StudentID)
                    .Include(l => l.LectureID)
                    .ToList();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateExam(Exam exam)
        {
            try
            {
                _dbContext.Entry(exam).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
