using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IModule
    {
        public List<Module> GetModules();
        public Module GetModule(int id);
        public void AddModule(Module module);
        public void UpdateModule(Module module);
        public Module DeleteModule(int id);
        public bool CheckModule(int id);
    }
}
