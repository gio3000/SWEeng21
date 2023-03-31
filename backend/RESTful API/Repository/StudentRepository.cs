using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class StudentRepository : IStudent
    {
        readonly DatabaseContext _dbContext = new();
        public StudentRepository(DatabaseContext dbContext) 
        {
            _dbContext = dbContext;
        }

        public void AddStudent(Student student)
        {
            try
            {
                _dbContext.Students.Add(student);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckStudent(int id)
        {
            return _dbContext.Students.Any(s => s.StudentID == id);
        }

        public Student DeleteStudent(int id)
        {
            try
            {
                Student? student = _dbContext.Students.Single(s => s.StudentID == id);

                if (student != null)
                {
                    _dbContext.Students.Remove(student);
                    _dbContext.SaveChanges();
                    return student;
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

        public Student GetStudent(int id)
        {
            try
            {
                Student? student = _dbContext.Students
                    .Include(u => u.UserID)
                    .Include(c => c.CourseID)
                    .Single(s => s.StudentID == id);
                if (student != null)
                {
                    return student;
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

        public List<Student> GetStudents()
        {
            try
            {
                return _dbContext.Students
                    .Include(u => u.UserID)
                    .Include(c => c.CourseID)
                    .ToList();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateStudent(Student student)
        {
            try
            {
                _dbContext.Entry(student).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
