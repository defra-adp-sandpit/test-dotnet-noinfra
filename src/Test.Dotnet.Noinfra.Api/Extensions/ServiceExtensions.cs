using Test.Dotnet.Noinfra.Core.Interfaces;
using Test.Dotnet.Noinfra.Core.Services;

namespace Test.Dotnet.Noinfra.Api.Extensions;
public static class ServiceExtensions
{
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        services.AddTransient<IItemService, ItemService>();
        return services;
    }
}
