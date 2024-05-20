using Test.Dotnet.Noinfra.Api.Models;
using Test.Dotnet.Noinfra.Core.Entities;

using AutoMapper;

namespace Test.Dotnet.Noinfra.Api.AutoMapper;

public class AutoMapperProfile : Profile
{
    public AutoMapperProfile()
    {
        CreateMap<ItemRequest, Item>();
    }
}
