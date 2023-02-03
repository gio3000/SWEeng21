using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ISecretary
    {
        public List<Secretary> GetSecretaries();
        public User GetSecretary(int id);
        public void AddSecretary(User user);
        public void UpdateSecretary(User user);
        public User DeleteSecretary(int id);
        public bool CheckSecretary(int id);
    }
}
