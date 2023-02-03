using RESTful_API.Models;

namespace RESTful_API.Interface
{
    public interface ILecture
    {
        public List<Lecture> GetLectures();
        public User GetLecture(int id);
        public void AddLecture(User user);
        public void UpdateLecture(User user);
        public User DeleteLecture(int id);
        public bool CheckLecture(int id);
    }
}
