using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ICourse
    {
        public List<Course> GetCourses();
        public User GetCourse(int id);
        public void AddCourse(User user);
        public void UpdateCourse(User user);
        public User DeleteCourse(int id);
        public bool CheckCourse(int id);
    }
}
