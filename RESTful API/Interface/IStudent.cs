using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface IStudent
    {
        public List<Student> GetStudents();
        public User GetStudent(int id);
        public void AddStudent(User user);
        public void UpdateStudent(User user);
        public User DeleteStudent(int id);
        public bool CheckStudent(int id);
    }
}
