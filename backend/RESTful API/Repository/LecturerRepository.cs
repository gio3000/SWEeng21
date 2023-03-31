using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class LecturerRepository : ILecturer
    {
        readonly DatabaseContext _dbContext = new();
        public LecturerRepository(DatabaseContext dbContext)
        {
            _dbContext= dbContext;
        }

        public void AddLecturer(Lecturer lecturer)
        {
            try
            {
                _dbContext.Lecturers.Add(lecturer);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckLecturer(int id)
        {
            return _dbContext.Lecturers.Any(e => e.LecturerID == id);
        }

        public Lecturer DeleteLecturer(int id)
        {
            try
            {
                Lecturer? lecturer = _dbContext.Lecturers.Single(l => l.LecturerID == id);

                if (lecturer != null)
                {
                    _dbContext.Lecturers.Remove(lecturer);
                    _dbContext.SaveChanges();
                    return lecturer;
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

        public Lecturer GetLecturer(int id)
        {
            try
            {
                Lecturer? lecturer = _dbContext.Lecturers
<<<<<<< Updated upstream
                    .Include(u => u.UserID)
=======
                    .Include(l => l.User)
>>>>>>> Stashed changes
                    .Single(l => l.LecturerID == id);
                if (lecturer != null)
                {
                    return lecturer;
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

        public List<Lecturer> GetLecturers()
        {
            try
            {
<<<<<<< Updated upstream
                return _dbContext.Lecturers.Include(u => u.UserID).ToList();
=======
                return _dbContext.Lecturers.Include(l => l.User).ToList();
>>>>>>> Stashed changes
            }
            catch
            {
                throw;
            }
        }

        public void UpdateLecturer(Lecturer lecturer)
        {
            try
            {
                _dbContext.Entry(lecturer).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
