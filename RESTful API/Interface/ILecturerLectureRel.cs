using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ILecturerLectureRel
    {
        public List<LecturerLectureRel> GetLecturerLectureRels();
        public LecturerLectureRel GetLecturerLectureRel(int id);
        public void AddLecturerLectureRel(LecturerLectureRel lecturerLectureRel);
        public void UpdateLecturerLectureRel(LecturerLectureRel lecturerLectureRel);
        public LecturerLectureRel DeleteLecturerLectureRel(int id);
        public bool CheckLecturerLectureRel(int id);
    }
}
