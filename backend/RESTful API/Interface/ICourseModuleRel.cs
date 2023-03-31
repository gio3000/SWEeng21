using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ICourseModuleRel
    {
        public List<CourseModuleRel> GetCourseModuleRels();
        public CourseModuleRel GetCourseModuleRel(int CourseId, int ModuleId);
        public void AddCourseModuleRel(CourseModuleRel courseModuleRel);
        public void UpdateCourseModuleRel(CourseModuleRel courseModuleRel);
        public CourseModuleRel DeleteCourseModuleRel(int CourseId, int ModuleId);
        public bool CheckCourseModuleRel(int CourseId, int ModuleId);
    }
}
