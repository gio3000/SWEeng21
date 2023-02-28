using Microsoft.AspNetCore.Mvc;
using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IUsers
    {
        public List<User> GetUsers();
        public User GetUser(int id);
        public void AddUser(User user);
        public void UpdateUser(User user);
        public User DeleteUser(int id);
        public bool CheckUser(int id);
    }
}
