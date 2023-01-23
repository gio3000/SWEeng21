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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            
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

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
