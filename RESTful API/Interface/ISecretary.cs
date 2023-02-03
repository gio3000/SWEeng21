using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ISecretary
    {
        public List<Secretary> GetSecretaries();
        public Secretary GetSecretary(int id);
        public void AddSecretary(Secretary secretary);
        public void UpdateSecretary(Secretary secretary);
        public Secretary DeleteSecretary(int id);
        public bool CheckSecretary(int id);
    }
}
