using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ILecturer
    {
        public List<Lecturer> GetLecturers();
        public User GetLecturer(int id);
        public void AddLecturer(User user);
        public void UpdateLecturer(User user);
        public User DeleteLecturer(int id);
        public bool CheckLecturer(int id);
    }
}
