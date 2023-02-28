using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;
using System.Reflection;

namespace RESTful_API.Repository
{
    public class LecturerLectureRelRepository : ILecturerLectureRel
    {
        readonly DatabaseContext _dbContext = new();
        public LecturerLectureRelRepository(DatabaseContext dbContext) 
        {
            _dbContext = dbContext;
        }

        public void AddLecturerLectureRel(LecturerLectureRel lecturerLectureRel)
        {
            try
            {
                _dbContext.LecturerLectureRels.Add(lecturerLectureRel);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckLecturerLectureRel(int LecturerId, int LectureId)
        {
            return _dbContext.LecturerLectureRels
                .Any(lr => lr.LecturerID == LecturerId && lr.LectureID == LectureId);
        }

        public LecturerLectureRel DeleteLecturerLectureRel(int LecturerId, int LectureId)
        {
            try
            {
                LecturerLectureRel? lecturerLectureRel = _dbContext.LecturerLectureRels
                    .Single(a => a.LecturerID == LecturerId && a.LectureID == LectureId);

                if (lecturerLectureRel != null)
                {
                    _dbContext.LecturerLectureRels.Remove(lecturerLectureRel);
                    _dbContext.SaveChanges();
                    return lecturerLectureRel;
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

        public LecturerLectureRel GetLecturerLectureRel(int LecturerId, int LectureId)
        {
            try
            {
                LecturerLectureRel? lecturerLectureRel = _dbContext.LecturerLectureRels
                    .Include(lr => lr.LecturerID)
                    .Include(l => l.LecturerID)
                    .Single(a => a.LecturerID == LecturerId && a.LectureID == LectureId);
                if (lecturerLectureRel != null)
                {
                    return lecturerLectureRel;
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

        public List<LecturerLectureRel> GetLecturerLectureRels()
        {
            try
            {
                return _dbContext.LecturerLectureRels
                    .Include(lr => lr.LecturerID)
                    .Include(l => l.LectureID)
                    .ToList();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateLecturerLectureRel(LecturerLectureRel lecturerLectureRel)
        {
            try
            {
                _dbContext.Entry(lecturerLectureRel).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
