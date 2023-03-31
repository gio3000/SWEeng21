using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ILecture
    {
        public List<Lecture> GetLectures();
        public Lecture GetLecture(int id);
        public void AddLecture(Lecture lecture);
        public void UpdateLecture(Lecture lecture);
        public Lecture DeleteLecture(int id);
        public bool CheckLecture(int id);
    }
}
