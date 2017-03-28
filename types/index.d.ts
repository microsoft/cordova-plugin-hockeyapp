declare namespace HockeyAppPlugin {
    interface HockeyApp {
        /**
         * Initializes the HockeyApp plugin, and configures it with the appropriate app ID and user settings
         * @param success Function that will be triggered when the initialization is successful
         * @param error Function that will be triggered when an error occurs trying to initialize the plugin
         * @param appId The ID of the app as provided by the HockeyApp portal
         * @param autoSend Specifies whether you would like crash reports to be automatically sent to the HockeyApp server when the end user restarts the app
         * @param ignoreDefaultHandler Specifies whether you would like to display the standard dialog when the app is about to crash
         * @param loginMode The mechanism to use in order to authenticate users
         * @param appSecret The app secret as provided by the HockeyApp portal
         *
         */
        start(
            success: () => void,
            error: (error: string) => void,
            appId: string,
            autoSend?:boolean,
            ignoreDefaultHandler?: boolean,
            loginMode?: LoginMode,
            appSecret?: string): void;

        /**
         * Display tester feedback user interface
         * @param success Function that will be triggered when the feedback action completes successfully
         * @param error   Function that will be triggered when the feedback action fails
         *
         */
        feedback(
            success: () => void,
            error: (error: string) => void): void;

        /**
         * Force an app crash
         */
        forceCrash(): void;

        /**
         * Check for a new version
         * @param success Function that will be triggered when the check update action completes successfully
         * @param error   Function that will be triggered when check update failed for some reason
         *
         */
        checkForUpdate(
            success: () => void,
            error: (error: string) => void): void;

        /**
         * Add arbitrary metadata to a crash, which will be displayed in crash reports
         * @param success Function that will be triggered when the metadata has been successfully added
         * @param error   Function that will be triggered when adding the metadata failed for some reason
         * @param data    JavaScript object that describes the metadata (i.e. properties and values) that you would like to attach to the next crash report
         *
         */
        addMetadata(
            success: () => void,
            error: (error: string) => void,
            data: any): void;
    }

    /**
     * Only ANONYMOUS is available for iOS devices, other modes will produce an error.
     */
    enum LoginMode {
        /** The user will not be prompted to authenticate */
        ANONYMOUS,
        /** The user will be prompted to specify a valid email address. You must also pass your appSecret when using this mode. */
        EMAIL_ONLY,
        /** The user will be prompted for a valid username/password combination. */
        EMAIL_PASSWORD,
        /** The user will not be prompted to authenticate, but the app will try to validate with the HockeyApp service. */
        VALIDATE
    }
}

interface Window {
    hockeyapp: HockeyAppPlugin.HockeyApp
}

declare var hockeyapp: HockeyAppPlugin.HockeyApp;
