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
                var user = await UserLogin(_userData.Email, _userData.Password);

                if (user != null)
                {
                    //create claims details based on the user information
                    var claims = new[] {
                        new Claim(JwtRegisteredClaimNames.Sub, _configuration["Jwt:Subject"]),
                        new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()),
                        new Claim(JwtRegisteredClaimNames.Iat, DateTime.UtcNow.ToString()),
                        new Claim("UserID", user.UserID.ToString()),
                        new Claim("First_Name", user.First_Name),
                        new Claim("Last_Name", user.Last_Name),
                        new Claim("Email", user.Email)
                    };

                    var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
                    var signIn = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
                    var token = new JwtSecurityToken(
                        _configuration["Jwt:Issuer"],
                        _configuration["Jwt:Audience"],
                        claims,
                        expires: DateTime.UtcNow.AddMinutes(10),
                        signingCredentials: signIn);


                    var response = new[]
                    {
                        new {Token = new JwtSecurityTokenHandler().WriteToken(token), User = user, Info = await Fetch(user)}
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

        private async Task<User> UserLogin(string email, string password)
        {
            return await _context.Users.FirstOrDefaultAsync(u => u.Email == email && u.Password == password);
        }

        private async Task<string> Fetch(User user)
        {
            
            var admin = await _context.Admins.FirstOrDefaultAsync(a => a.UserID == user.UserID);
            var student = await _context.Students.FirstOrDefaultAsync(s => s.UserID == user.UserID);
            var sectary = await _context.Secretarys.FirstOrDefaultAsync(s => s.UserID == user.UserID);
            var lecturer = await _context.Lecturers.FirstOrDefaultAsync(l => l.UserID == user.UserID);

            if (admin != null)
            {
                return JsonConvert.SerializeObject(admin, new JsonSerializerSettings() {
                                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                });
            } else if (student != null)
            {
                return JsonConvert.SerializeObject(student, new JsonSerializerSettings()
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                });
            } else if (sectary != null)
            {
                return JsonConvert.SerializeObject(sectary, new JsonSerializerSettings()
                {
                    ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                });
            } else if (lecturer != null)
            {
                return JsonConvert.SerializeObject(lecturer, new JsonSerializerSettings() { ReferenceLoopHandling = ReferenceLoopHandling.Ignore });
            } else
            {
                return null;
            }
        }
    }
}
