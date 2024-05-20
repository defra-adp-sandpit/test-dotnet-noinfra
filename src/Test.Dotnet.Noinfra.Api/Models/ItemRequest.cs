using System.ComponentModel.DataAnnotations;

namespace Test.Dotnet.Noinfra.Api.Models;

public class ItemRequest
{
    public int? Id { get; set; }
    [Required]
    public required string Name { get; set; }
}

