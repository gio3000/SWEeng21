using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class CourseRepository : ICourse
    {
        readonly DatabaseContext _dbContext = new();

        public CourseRepository(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void AddCourse(Course course)
        {
            try
            {
                _dbContext.Courses.Add(course);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckCourse(int id)
        {
            return _dbContext.Courses.Any(e => e.CourseID == id);
        }

        public Course DeleteCourse(int id)
        {
            try
            {
                Course? course = _dbContext.Courses.Single(a => a.CourseID == id);

                if (course != null)
                {
                    _dbContext.Courses.Remove(course);
                    _dbContext.SaveChanges();
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

        public Course GetCourse(int id)
        {
            try
            {
                Course? course = _dbContext.Courses.Include(c => c.Secretary).Single(a => a.CourseID == id);
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

        public List<Course> GetCourses()
        {
            try
            {
                return _dbContext.Courses.Include(c => c.Secretary).ToList();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateCourse(Course course)
        {
            try
            {
                _dbContext.Entry(course).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
