using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class AdminRepository : IAdmin
    {
        readonly DatabaseContext _dbContext = new();

        public AdminRepository(DatabaseContext dbContext) 
        { 
            _dbContext = dbContext;
        }

        public List<User> GetAdmins()
        {
            try
            {
                return _dbContext.Users.ToList();
            }
            catch
            {
                throw;
            }
        }

        public User GetAdmin(int id)
        {
            try
            {
                User? user = _dbContext.Users.Find(id);
                if (user != null)
                {
                    return user;
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

        public void AddUser(User user)
        {
            try
            {
                _dbContext.Users.Add(user);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateUser(User user)
        {
            try
            {
                _dbContext.Entry(user).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public User DeleteUser(int id)
        {
            try
            {
                User? user = _dbContext.Users.Find(id);

                if (user != null)
                {
                    _dbContext.Users.Remove(user);
                    _dbContext.SaveChanges();
                    return user;
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

        public bool CheckUser(int id)
        {
            return _dbContext.Users.Any(e => e.UserID == id);
        }
    }
}
