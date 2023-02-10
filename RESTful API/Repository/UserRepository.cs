using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class UserRepository : IUsers
    {
        readonly DatabaseContext _dbContext = new();

        public UserRepository(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        public List<User> GetUsers()
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

        public User GetUser(int id)
        {
            try
            {
                User? user = _dbContext.Users.Single(u => u.UserID == id);
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
                User? user = _dbContext.Users.Single(u => u.UserID == id);

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
