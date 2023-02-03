using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ICourseModuleRel
    {
        public List<CourseModuleRel> GetCourseModuleRels();
        public User GetCourseModuleRel(int id);
        public void AddCourseModuleRel(User user);
        public void UpdateCourseModuleRel(User user);
        public User DeleteCourseModuleRel(int id);
        public bool CheckCourseModuleRel(int id);
    }
}
