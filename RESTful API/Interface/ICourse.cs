using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ICourse
    {
        public List<Course> GetCourses();
        public Course GetCourse(int id);
        public void AddCourse(Course course);
        public void UpdateCourse(Course course);
        public Course DeleteCourse(int id);
        public bool CheckCourse(int id);
    }
}
