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

        public List<Admin> GetAdmins()
        {
            try
            {
                return _dbContext.Admins.Include(u => u.UserID).ToList();
            }
            catch
            {
                throw;
            }
        }

        public Admin GetAdmin(int id)
        {
            try
            {
                Admin? admin = _dbContext.Admins.Include(u => u.UserID).Single(a => a.AdminID == id);
                if (admin != null)
                {
                    return admin;
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

        public void AddAdmin(Admin admin)
        {
            try
            {
                _dbContext.Admins.Add(admin);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateAdmin(Admin admin)
        {
            try
            {
                _dbContext.Entry(admin).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public Admin DeleteAdmin(int id)
        {
            try
            {
                Admin? admin = _dbContext.Admins.Single(a => a.AdminID == id);

                if (admin != null)
                {
                    _dbContext.Admins.Remove(admin);
                    _dbContext.SaveChanges();
                    return admin;
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

        public bool CheckAdmin(int id)
        {
            return _dbContext.Admins.Any(e => e.AdminID == id);
        }
    }
}
