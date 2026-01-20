import AppMetricaCore

extension AppDelegate {

    func configureAppMetrica() {
        guard let configuration = AppMetricaConfiguration(
            apiKey: Secrets.yandex_metrica.rawValue
        ) else { return }

        configuration.areLogsEnabled = true
        configuration.sessionsAutoTracking = true
        configuration.locationTracking = false

        AppMetrica.activate(with: configuration)
        AppMetrica.reportEvent(name: "app_launched")

        Logger.log(.info, "AppMetrica activated successfully")
    }
    
}
