using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class LectureRepository : ILecture
    {
        readonly DatabaseContext _dbContext = new();
        public LectureRepository(DatabaseContext dbContext) 
        {
            _dbContext = dbContext;
        }

        public void AddLecture(Lecture lecture)
        {
            try
            {
                _dbContext.Lectures.Add(lecture);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckLecture(int id)
        {
            return _dbContext.Lectures.Any(l => l.LectureID == id);
        }

        public Lecture DeleteLecture(int id)
        {
            try
            {
                Lecture? lecture = _dbContext.Lectures.Single(l => l.LectureID == id);

                if (lecture != null)
                {
                    _dbContext.Lectures.Remove(lecture);
                    _dbContext.SaveChanges();
                    return lecture;
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

        public Lecture GetLecture(int id)
        {
            try
            {
                Lecture? lecture = _dbContext.Lectures
                    .Include(m => m.ModuleID)
                    .Single(l => l.LectureID == id);
                if (lecture != null)
                {
                    return lecture;
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

        public List<Lecture> GetLectures()
        {
            try
            {
                return _dbContext.Lectures
                    .Include(m => m.ModuleID)
                    .ToList();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateLecture(Lecture lecture)
        {
            try
            {
                _dbContext.Entry(lecture).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
