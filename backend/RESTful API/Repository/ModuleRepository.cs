using Microsoft.EntityFrameworkCore;
using RESTful_API.Interface;
using RESTful_API.Models;

namespace RESTful_API.Repository
{
    public class ModuleRepository : IModule
    {
        readonly DatabaseContext _dbContext = new();

        public ModuleRepository(DatabaseContext dbContext)
        {
            _dbContext = dbContext;
        }

        public void AddModule(Module module)
        {
            try
            {
                _dbContext.Modules.Add(module);
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }

        public bool CheckModule(int id)
        {
            return _dbContext.Modules.Any(m => m.ModuleID == id);
        }

        public Module DeleteModule(int id)
        {
            try
            {
                Module? module = _dbContext.Modules.Single(m => m.ModuleID == id);

                if (module != null)
                {
                    _dbContext.Modules.Remove(module);
                    _dbContext.SaveChanges();
                    return module;
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

        public Module GetModule(int id)
        {
            try
            {
                Module? module = _dbContext.Modules.Single(m => m.ModuleID == id);
                if (module != null)
                {
                    return module;
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

        public List<Module> GetModules()
        {
            try
            {
                return _dbContext.Modules.ToList();
            }
            catch
            {
                throw;
            }
        }

        public void UpdateModule(Module module)
        {
            try
            {
                _dbContext.Entry(module).State = EntityState.Modified;
                _dbContext.SaveChanges();
            }
            catch
            {
                throw;
            }
        }
    }
}
