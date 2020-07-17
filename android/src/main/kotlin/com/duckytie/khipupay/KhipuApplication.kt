package com.duckytie.khipupay

import com.browser2app.khenshin.Khenshin
import com.browser2app.khenshin.KhenshinApplication
import com.browser2app.khenshin.KhenshinInterface
import io.flutter.app.FlutterApplication

class KhipuApplication: FlutterApplication(), KhenshinApplication {
    private val khenshinInterface: KhenshinInterface = Khenshin.KhenshinBuilder()
            .setApplication(this)
            .setAPIUrl("https://khipu.com/app/enc/")
            .setAllowCredentialsSaving(true)
            .setHideWebAddressInformationInForm(true)
            .setMainButtonStyle(Khenshin.CONTINUE_BUTTON_IN_FORM)
            .setClearCookiesBeforeStart(true)
            .build()

    override fun getKhenshin(): KhenshinInterface {
        return khenshinInterface
    }
}
