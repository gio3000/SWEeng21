using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class CourseModuleRelRepository : ICourseModuleRel
    {
        readonly DatabaseContext _dbContext = new();

        public CourseModuleRelRepository(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void AddCourseModuleRel(CourseModuleRel courseModuleRel)
        {
            try
            {
                _dbContext.CourseModuleRels.Add(courseModuleRel);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckCourseModuleRel(int CourseId, int ModuleId)
        {
            return _dbContext.CourseModuleRels
                .Any(a => a.CourseID == CourseId && a.ModuleID == ModuleId);
        }

        public CourseModuleRel DeleteCourseModuleRel(int CourseId, int ModuleId)
        {
            try
            {
                CourseModuleRel? courseModuleRel = _dbContext.CourseModuleRels
                    .Single(a => a.CourseID == CourseId && a.ModuleID == ModuleId);

                if (courseModuleRel != null)
                {
                    _dbContext.CourseModuleRels.Remove(courseModuleRel);
                    _dbContext.SaveChanges();
                    return courseModuleRel;
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

        public CourseModuleRel GetCourseModuleRel(int CourseId, int ModuleId)
        {
            try
            {
                CourseModuleRel? courseModuleRel = _dbContext.CourseModuleRels
                    .Include(c => c.CourseID)
                    .Include(m => m.ModuleID)
                    .Single(a => a.CourseID == CourseId && a.ModuleID == ModuleId);
                if (courseModuleRel != null)
                {
                    return courseModuleRel;
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

        public List<CourseModuleRel> GetCourseModuleRels()
        {
            try
            {
                return _dbContext.CourseModuleRels
                    .Include(c => c.CourseID)
                    .Include(m => m.ModuleID)
                    .ToList();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateCourseModuleRel(CourseModuleRel courseModuleRel)
        {
            try
            {
                _dbContext.Entry(courseModuleRel).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
