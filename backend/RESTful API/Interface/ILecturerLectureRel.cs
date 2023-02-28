using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ILecturerLectureRel
    {
        public List<LecturerLectureRel> GetLecturerLectureRels();
        public LecturerLectureRel GetLecturerLectureRel(int LecturerId, int LectureId);
        public void AddLecturerLectureRel(LecturerLectureRel lecturerLectureRel);
        public void UpdateLecturerLectureRel(LecturerLectureRel lecturerLectureRel);
        public LecturerLectureRel DeleteLecturerLectureRel(int LecturerId, int LectureId);
        public bool CheckLecturerLectureRel(int LecturerId, int LectureId);
    }
}
