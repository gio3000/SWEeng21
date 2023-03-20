using Microsoft.EntityFrameworkCore;

namespace RESTful_API.Models
{
    public partial class DatabaseContext : DbContext
    {
        public DatabaseContext()
        {
        }

        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options)
        {
        }

        public virtual DbSet<User>? Users { get; set; }
        public virtual DbSet<Admin> Admins { get; set; }
        public virtual DbSet<Course> Courses { get; set; }
        public virtual DbSet<CourseModuleRel> CourseModuleRels { get; set; }
        public virtual DbSet<Exam> Exams { get; set; }
        public virtual DbSet<Lecture> Lectures { get; set; }
        public virtual DbSet<Lecturer> Lecturers { get; set; }
        public virtual DbSet<LecturerLectureRel> LecturerLectureRels { get; set; }
        public virtual DbSet<Module> Modules { get; set; }
        public virtual DbSet<Secretary> Secretarys { get; set; }
        public virtual DbSet<Student> Students { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            // User table
            modelBuilder.Entity<User>(entity =>
            {
                entity.ToTable("User");
                entity.Property(e => e.UserID).HasColumnName("UserID");
                entity.Property(e => e.First_Name).HasMaxLength(40).IsUnicode(true);
                entity.Property(e => e.Last_Name).HasMaxLength(40).IsUnicode(true);
                entity.Property(e => e.Email).HasMaxLength(60).IsUnicode(true);
                entity.Property(e => e.Hash_Count).IsUnicode(false);
                entity.Property(e => e.Salt).HasMaxLength(32).IsUnicode(true);
                entity.Property(e => e.Password).HasMaxLength(64).IsUnicode(true);
            });

            // Admin table
            modelBuilder.Entity<Admin>(entity =>
            {
                entity.ToTable("Admin");
                entity.Property(e => e.AdminID).HasColumnName("AdminID");
                entity.Property(e => e.UserID).IsUnicode(false);
            });
            modelBuilder.Entity<Admin>()
                .HasOne<User>(a => a.User)
                .WithMany(u => u.Admins)
                .HasForeignKey(a => a.UserID);

            // Course table
            modelBuilder.Entity<Course>(entity =>
            {
                entity.ToTable("Course");
                entity.Property(e => e.CourseID).HasColumnName("CourseID");
                entity.Property(e => e.CourseName).HasMaxLength(10).IsUnicode(true);
            });

            // CourseModuleRel table
            modelBuilder.Entity<CourseModuleRel>().HasKey(cm => new { cm.CourseID, cm.ModuleID });

            modelBuilder.Entity<CourseModuleRel>()
                .HasOne<Course>(cm => cm.Course)
                .WithMany(c => c.CourseModuleRels)
                .HasForeignKey(cm => cm.CourseID);


            modelBuilder.Entity<CourseModuleRel>()
                .HasOne<Module>(cm => cm.Module)
                .WithMany(m => m.CourseModuleRels)
                .HasForeignKey(cm => cm.ModuleID);

            // Exam table
            modelBuilder.Entity<Exam>(entity =>
            {
                entity.ToTable("Exam");
                entity.Property(e => e.ExamID).HasColumnName("ExamID");
                entity.Property(e => e.LectureID).IsUnicode(false);
                entity.Property(e => e.StudentID).IsUnicode(false);
                entity.Property(e => e.Grade).IsUnicode(false);
                entity.Property(e => e.Semester).HasMaxLength(20).IsUnicode(true);
                entity.Property(e => e.CountToAverage).IsUnicode(false);
            });
            modelBuilder.Entity<Exam>()
                .HasOne<Lecture>(e => e.Lecture)
                .WithMany(l => l.Exams)
                .HasForeignKey(e => e.LectureID);

            modelBuilder.Entity<Exam>()
                .HasOne<Student>(e => e.Student)
                .WithMany(s => s.Exams)
                .HasForeignKey(e => e.StudentID);

            // Lecture table
            modelBuilder.Entity<Lecture>(entity =>
            {
                entity.ToTable("Lecture");
                entity.Property(e => e.LectureID).HasColumnName("LectureID");
                entity.Property(e => e.ModuleID).IsUnicode(false);
                entity.Property(e => e.LectureName).HasMaxLength(40).IsUnicode(true);
            });
            modelBuilder.Entity<Lecture>()
                .HasOne<Module>(l => l.Module)
                .WithMany(m => m.Lectures)
                .HasForeignKey(l => l.ModuleID);

            // Lecturer table
            modelBuilder.Entity<Lecturer>(entity =>
            {
                entity.ToTable("Lecturer");
                entity.Property(e => e.LecturerID).HasColumnName("LecturerID");
                entity.Property(e => e.UserID).IsUnicode(false);
            });
            modelBuilder.Entity<Lecturer>()
                .HasOne<User>(l => l.User)
                .WithMany(u => u.Lecturers)
                .HasForeignKey(l => l.UserID);

            // LecturerLectureRel table
            modelBuilder.Entity<LecturerLectureRel>().HasKey(ll => new { ll.LecturerID, ll.LectureID });

            modelBuilder.Entity<LecturerLectureRel>()
                .HasOne<Lecturer>(ll => ll.Lecturer)
                .WithMany(l => l.LecturerLectureRels)
                .HasForeignKey(ll => ll.LecturerID);

            modelBuilder.Entity<LecturerLectureRel>()
                .HasOne<Lecture>(ll => ll.Lecture)
                .WithMany(l => l.LecturerLectureRels)
                .HasForeignKey(l => l.LectureID);

            // Module table
            modelBuilder.Entity<Module>(entity =>
            {
                entity.ToTable("Module");
                entity.Property(e => e.ModuleID).HasColumnName("ModuleID");
                entity.Property(e => e.ModuleName).HasMaxLength(40).IsUnicode(true);
                entity.Property(e => e.CTS).IsUnicode(false);
                entity.Property(e => e.Status).HasMaxLength(20).IsUnicode(true);
            });

            // Secretary table
            modelBuilder.Entity<Secretary>(entity =>
            {
                entity.ToTable("Secretary");
                entity.Property(e => e.SecretaryID).HasColumnName("SecretaryID");
                entity.Property(e => e.UserID).IsUnicode(false);
                entity.Property(e => e.Name).HasMaxLength(40).IsUnicode(true); 
            });
            modelBuilder.Entity<Secretary>()
                .HasOne<User>(s => s.User)
                .WithMany(u => u.Secretaries)
                .HasForeignKey(s => s.UserID);

            // Student table
            modelBuilder.Entity<Student>(entity =>
            {
                entity.ToTable("Student");
                entity.Property(e => e.StudentID).HasColumnName("StudentID");
                entity.Property(e => e.CourseID).IsUnicode(false);
                entity.Property(e => e.UserID).IsUnicode(false);
                entity.Property(e => e.MatriculationNr).IsUnicode(false);
            });
            modelBuilder.Entity<Student>()
                .HasOne<User>(s => s.User)
                .WithMany(u => u.Students)
                .HasForeignKey(s => s.UserID);

            modelBuilder.Entity<Student>()
                .HasOne<Course>(s => s.Course)
                .WithMany(c => c.Students)
                .HasForeignKey(s => s.CourseID);

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
