using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IAdmin
    {
        public List<Admin> GetÁdmins();
        public Admin GetAdmin(int id);
        public void AddAdmin(Admin admin);
        public void UpdateAdmin(Admin admin);
        public Admin DeleteAdmin(int id);
        public bool CheckAdmin(int id);
    }
}
