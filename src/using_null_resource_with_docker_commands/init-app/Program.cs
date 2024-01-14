var builder = WebApplication.CreateBuilder(args);

var app = builder.Build();

app.MapGet("/", async context =>
{
    await context.Response.WriteAsync("That's a temporal image. Waiting for the proper image.");
});

app.MapGet("/health", async context =>
{
    await context.Response.WriteAsync("Ok");
});

app.Run();
