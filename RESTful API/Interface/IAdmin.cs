using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IAdmin
    {
        public List<Admin> GetÁdmins();
        public User GetAdmin(int id);
        public void AddAdmin(User user);
        public void UpdateAdmin(User user);
        public User DeleteAdmin(int id);
        public bool CheckAdmin(int id);
    }
}
