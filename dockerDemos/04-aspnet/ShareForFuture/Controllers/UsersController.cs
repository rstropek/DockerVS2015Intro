using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ShareForFuture.Data;

namespace ShareForFuture.Controllers;

[Route("api/[controller]")]
[ApiController]
public class UsersController : ControllerBase
{
    private readonly S4fDbContext _context;

    public UsersController(S4fDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<ActionResult<IEnumerable<User>>> GetUsers()
    {
        return await _context.Users.ToListAsync();
    }

    [HttpGet("{id}")]
    public async Task<ActionResult<User>> GetUser(int id)
    {
        var user = await _context.Users.FindAsync(id);

        if (user == null)
        {
            return NotFound();
        }

        return user;
    }

    [HttpPut("{id}")]
    public async Task<IActionResult> PutUser(int id, User user)
    {
        if (id != user.Id)
        {
            return BadRequest();
        }

        _context.Entry(user).State = EntityState.Modified;

        try
        {
            await _context.SaveChangesAsync();
        }
        catch (DbUpdateConcurrencyException)
        {
            if (!UserExists(id))
            {
                return NotFound();
            }
            else
            {
                throw;
            }
        }

        return NoContent();
    }

    [HttpPost]
    public async Task<ActionResult<User>> PostUser(User user)
    {
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetUser", new { id = user.Id }, user);
    }

    [HttpPost("create-demo")]
    public async Task<ActionResult<User>> GenerateDemoUser()
    {
        var user = new User()
        {
            FirstName = "Foo",
            LastName = "Bar",
            Street = "Anywhere",
            City = "Somehwere",
            ZipCode = "9999",
            Country = "AT",
            ContactPhone = "+4312345678",
            ContactEmail = "foo@bar.com",
            Identities = new List<Identity>
            {
                new()
                {
                    Provider = IdentityProvider.Google,
                    SubjectId = "foobar@google"
                },
                new()
                {
                    Provider = IdentityProvider.Microsoft,
                    SubjectId = "foobar@google"
                },
            },
        };
        _context.Users.Add(user);
        await _context.SaveChangesAsync();

        return CreatedAtAction("GetUser", new { id = user.Id }, user);
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> DeleteUser(int id)
    {
        var user = await _context.Users.FindAsync(id);
        if (user == null)
        {
            return NotFound();
        }

        _context.Users.Remove(user);
        await _context.SaveChangesAsync();

        return NoContent();
    }

    private bool UserExists(int id)
    {
        return _context.Users.Any(e => e.Id == id);
    }
}
