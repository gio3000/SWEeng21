using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ILecturerLectureRel
    {
        public List<LecturerLectureRel> GetLecturerLectureRels();
        public User GetLecturerLectureRel(int id);
        public void AddLecturerLectureRel(User user);
        public void UpdateLecturerLectureRel(User user);
        public User DeleteLecturerLectureRel(int id);
        public bool CheckLecturerLectureRel(int id);
    }
}
