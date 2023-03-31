using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;
using System.Security.Cryptography;
using System.Text;

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
                var hash = HashPasword(user.Password, out var salt, user.Hash_Count);
                user.Password = hash;
                user.Salt = Convert.ToHexString(salt);

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
                var hash = HashPasword(user.Password, out var salt, user.Hash_Count);
                user.Password = hash;
                user.Salt = Convert.ToHexString(salt);


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

        public string HashPasword(string password, out byte[] salt, int count)
        {
            const int keySize = 32;
            const int iterations = 350000;
            HashAlgorithmName hashAlgorithm = HashAlgorithmName.SHA512;

            salt = RandomNumberGenerator.GetBytes(keySize);
            var hash = Rfc2898DeriveBytes.Pbkdf2(
                Encoding.UTF8.GetBytes(password),
                salt,
                count,
                hashAlgorithm,
                keySize);
            return Convert.ToHexString(hash);
        }
    }
}
