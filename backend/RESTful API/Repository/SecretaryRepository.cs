using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class SecretaryRepository : ISecretary
    {
        readonly DatabaseContext _dbContext = new();
        public SecretaryRepository(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void AddSecretary(Secretary secretary)
        {
            try
            {
                _dbContext.Secretarys.Add(secretary);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckSecretary(int id)
        {
            return _dbContext.Secretarys.Any(s => s.SecretaryID == id);
        }

        public Secretary DeleteSecretary(int id)
        {
            try
            {
                Secretary? secretary = _dbContext.Secretarys.Single(s => s.SecretaryID == id);

                if (secretary != null)
                {
                    _dbContext.Secretarys.Remove(secretary);
                    _dbContext.SaveChanges();
                    return secretary;
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

        public List<Secretary> GetSecretaries()
        {
            try
            {
                return _dbContext.Secretarys.Include(u => u.UserID).ToList();
            }
            catch
            {
                throw;
            }
        }

        public Secretary GetSecretary(int id)
        {
            try
            {
                Secretary? secretary= _dbContext.Secretarys
                    .Include(u => u.UserID)
                    .Single(s => s.SecretaryID == id);
                if (secretary != null)
                {
                    return secretary;
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

        public void UpdateSecretary(Secretary secretary)
        {
            try
            {
                _dbContext.Entry(secretary).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
