using System;
using System.Collections.Generic;
using Newtonsoft.Json;
using Sieve.Models;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using TradeProjectAppAvalonia.Model;

namespace TradeProjectAppAvalonia.Classes
{


    public class ManufacturerService
    {
        private readonly HttpClient _httpClient = new HttpClient();
        private readonly Messages _messages = new Messages();
        private const string manufacturerUrl = "https://localhost:44330/api/manufacturer";

        public ManufacturerService()
        {
        }

        // Получение списка производителей с фильтрацией через Sieve
        public Task<List<Manufacturer>?> GetManufacturersAsync(SieveModel sieveModel) =>
            SendRequestAsync<List<Manufacturer>>(HttpMethod.Get, $"{manufacturerUrl}?Filters={sieveModel.Filters}&Sorts={sieveModel.Sorts}&Page={sieveModel.Page}&PageSize={sieveModel.PageSize}");

        // Получение производителя по ID
        public Task<Manufacturer?>? GetManufacturerByIdAsync(int id) =>
            SendRequestAsync<Manufacturer>(HttpMethod.Get, $"{manufacturerUrl}/{id}");

        // Создание нового производителя
        public Task<Manufacturer?>? CreateManufacturerAsync(Manufacturer manufacturer) =>
            SendRequestAsync<ApiResponse>(HttpMethod.Post, manufacturerUrl, manufacturer)
                ?.ContinueWith(t => t.Result?.Manufacturer);

        // Обновление существующего производителя
        public Task<Manufacturer?>? UpdateManufacturerAsync(int id, Manufacturer manufacturer) =>
            id == manufacturer.ManufacturerId
                ? SendRequestAsync<Manufacturer>(HttpMethod.Put, $"{manufacturerUrl}/{id}", manufacturer)
                : throw new ArgumentException("ID производителя не совпадает.");

        // Удаление производителя
        public async Task<bool> DeleteManufacturerAsync(int id)
        {
            var success = await SendRequestAsync<object>(HttpMethod.Delete, $"{manufacturerUrl}/{id}") != null;
            if (success)
            {
                Console.WriteLine($"Производитель с ID {id} успешно удалён.");
            }
            return success;
        }

        // Универсальный метод для отправки запросов и обработки ответов
        private async Task<T?> SendRequestAsync<T>(HttpMethod method, string url, object? data = null)
        {
            try
            {
                var request = new HttpRequestMessage(method, url);
                if (data != null)
                {
                    var settings = new JsonSerializerSettings
                    {
                        ReferenceLoopHandling = ReferenceLoopHandling.Ignore
                    };
                    var jsonData = JsonConvert.SerializeObject(data, settings);
                    request.Content = new StringContent(jsonData, Encoding.UTF8, "application/json");
                }

                var response = await _httpClient.SendAsync(request);
                var json = await response.Content.ReadAsStringAsync();

                if (!response.IsSuccessStatusCode)
                {
                    _messages.ShowError(json);
                    return default;
                }

                return JsonConvert.DeserializeObject<T>(json);
            }
            catch (HttpRequestException ex)
            {
                Console.WriteLine($"Ошибка при выполнении запроса: {ex.Message}");
                return default;
            }
            catch (Exception ex)
            {
                _messages.ShowError($"Неизвестная ошибка: {ex.Message}");
                return default;
            }

            

        }
    }
}
