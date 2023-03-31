using Microsoft.AspNetCore.Cors;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Razor.Infrastructure;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Newtonsoft.Json;
using RESTful_API.Interface;
using RESTful_API.Models;
using RESTful_API.Repository;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Text.Json.Serialization;

namespace RESTful_API.Controllers
{
    [EnableCors("MyPolicy")]
    [Route("api/token")]
    [ApiController]
    public class TokenController : ControllerBase
    {
        public IConfiguration _configuration;
        private readonly DatabaseContext _context;

        public TokenController(IConfiguration config, DatabaseContext context)
        {
            _configuration = config;
            _context = context;
        }

        [HttpPost]
        public async Task<IActionResult> Post(User _userData)
        {
            if (_userData != null && _userData.Email != null && _userData.Password != null)
            {
                var user = await UserLogin(_userData.Email, _userData.Password, _userData);

                if (user != null)
                {
                    //create claims details based on the user information
                    var claims = new[] {
                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"]),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                        new Claim("UserID", user.UserID.ToString()),
                        new Claim("Email", user.Email)
                    };

                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
                    var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                    var token = new JwtSecurityToken(
                        _configuration["Jwt:Issuer"],
                        _configuration["Jwt:Audience"],
                        claims,
                        expires: DateTime.UtcNow.AddMinutes(60), 
                        signingCredentials: signIn);


                    var response = new[]
                    {
                        new {Token = new JwtSecurityTokenHandler().WriteToken(token), User = user, ID = FetchID(user.UserID, user.Role.ToString())}
                    };

                    return Ok(JsonConvert.SerializeObject(response));
                }
                else
                {
                    return BadRequest("Invalid credentials");
                }
            }
            else
            {
                return BadRequest();
            }
        }

        private async Task<User> UserLogin(string email, string password, User userData)
        {
            var user = await GetUser(email);
            if (user != null) {
                var hashToCompare = Rfc2898DeriveBytes.Pbkdf2(Encoding.ASCII.GetBytes(password), Encoding.ASCII.GetBytes(user.Salt), user.Hash_Count, HashAlgorithmName.SHA512, 32);
                if (hashToCompare.SequenceEqual(Convert.FromHexString(user.Password)))
                {
                    return user;
                }
            }   

            return null;
        }

        private int FetchID(int id, string role)
        {
            switch (role)
            {
                case "Admin":
                    return _context.Admins.Where(a => a.UserID == id).Select(y => y.AdminID).Single();
                case "Student":
                    return _context.Students.Where(a => a.UserID == id).Select(y => y.StudentID).Single();
                case "Lecturer":
                    return _context.Lecturers.Where(a => a.UserID == id).Select(y => y.LecturerID).Single();
                case "Secretary":
                    return _context.Secretarys.Where(a => a.UserID == id).Select(y => y.SecretaryID).Single();
                default: return 0;
            }
            
        }


        private async Task<User> GetUser(string email)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email);
        }
    }
}
