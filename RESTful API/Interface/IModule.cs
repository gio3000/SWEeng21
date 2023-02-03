using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IModule
    {
        public List<Module> GetModules();
        public User GetModule(int id);
        public void AddModule(User user);
        public void UpdateModule(User user);
        public User DeleteModule(int id);
        public bool CheckModule(int id);
    }
}
