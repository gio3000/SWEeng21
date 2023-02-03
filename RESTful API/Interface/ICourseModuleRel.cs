using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ICourseModuleRel
    {
        public List<CourseModuleRel> GetCourseModuleRels();
        public CourseModuleRel GetCourseModuleRel(int id);
        public void AddCourseModuleRel(CourseModuleRel courseModuleRel);
        public void UpdateCourseModuleRel(CourseModuleRel courseModuleRel);
        public CourseModuleRel DeleteCourseModuleRel(int id);
        public bool CheckCourseModuleRel(int id);
    }
}
