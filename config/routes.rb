Rails.application.routes.draw do
    # rotas gerais da aplicação
    get 'login' => 'application#login'
    get 'logout' => 'application#logout'
    root 'application#login'

    # rotas do módulo do professor responsável
    scope 'responsavel', module: 'app', as: 'responsible_teacher' do
        # dashboard
        get '/' => 'responsible_teacher#home'

        resources :students, module: 'responsibleteacher', path: 'academicos'
        resources :teachers, module: 'responsibleteacher', path: 'professores'

        resources :calendars, module: 'responsibleteacher', path: 'calendarios', format: :js
        get 'calendarios/:year/:half/:tcc' => 'responsibleteacher/calendars#show', module: 'app'
        get 'calendarios/:year/:half/:tcc/timeline' => 'responsibleteacher/calendars#timeline', module: 'app'
        post 'calendarios/:id/timeline/save' => 'responsibleteacher/calendars#save_timeline', module: 'app'

        resources :timelines, module: 'responsibleteacher', only: [:index, :show, :new, :create, :destroy]
        get 'timelines/:year/:half/:tcc' => 'responsibleteacher/timelines#list', module: 'responsibleteacher'

        # we will be refactored
        get 'calendarios1' => 'responsible_teacher#calendars'
        get 'timelines1' => 'responsible_teacher#timelines'
        get 'bancas' => 'responsible_teacher#banks'
        get 'perfil' => 'responsible_teacher#profile'
        get 'orientacoes' => 'responsible_teacher#orientations'
        get 'orientacoes/:timeline' => 'responsible_teacher#orientations_by_timeline'
        get 'orientacao/:id' => 'responsible_teacher#orientation'
    end

    # rotas do módulo do acadêmico
    scope 'academico', module: 'app', as: 'student' do
        get '/' => 'student#timeline'
        get 'item' => 'student#item'
        get 'perfil' => 'student#profile'
    end

    # rotas do módulo do professor orientador / membro de banca
    scope 'professor', module: 'app', as: 'teacher' do
        get '/' => 'teacher#home'
        get 'timelines' => 'teacher#timelines'
        get 'entregas' => 'teacher#deliveries'
        get 'perfil' => 'teacher#profile'
        resources :orientacoes, :controller => 'orientations'
        get 'bancas' => 'teacher#banks'
        post 'orientacoes/:id/edit' => 'orientations#editPost'
    end

    # rotas do módulo do professor de TCC 1
    scope 'tcc1', module: 'app', as: 'tcc1' do
        get '/' => 'tcc1#timelines'
        get '/entregas' => 'tcc1#deliveries'
    end

    # rotas da api
    namespace :api do
        # rotas da api para estudantes
        get 'student/all' => 'student#all'
        post 'student/new' => 'student#new'
        put 'student/edit/:id' => 'student#edit'
        delete 'student/delete/:id' => 'student#delete'
        put 'student/profile/:id' => 'student#editProfile'

        # rotas da api para professores
        get 'teacher/all' => 'teacher#all'
        post 'teacher/new' => 'teacher#new'
        put 'teacher/edit/:id' => 'teacher#edit'
        delete 'teacher/delete/:id' => 'teacher#delete'
        get 'teacher/pending/tcc1' => 'teacher#getPendingDocumentsTcc1'
        get 'teacher/pending/:id' => 'teacher#getPendingDocuments'
        get 'teacher/document/reprove/:id' => 'teacher#reproveDocument'
        get 'teacher/document/approve/:id' => 'teacher#approveDocument'
        put 'teacher/profile/:id' => 'teacher#editProfile'

        # rotas da api para base timeline
        get 'timeline/base/search/:year/:half/:tcc' => 'base_timeline#searchBase'
        get 'timeline/base/:id' => 'base_timeline#getBase'
        get 'timeline/base' => 'base_timeline#getBase'
        post 'timeline/base/item/new' => 'base_timeline#newItemBase'
        put 'timeline/base/item/edit' => 'base_timeline#editItemBase'
        delete 'timeline/base/item/delete/:id' => 'base_timeline#deleteItemBase'
        post 'timeline/base/json/:id' => 'base_timeline#setJson'

        # rotas da api para timeline
        post 'timeline/new' => 'timeline#new'
        get 'timeline/find/:year/:half/:tcc' => 'timeline#find'
        get 'timeline/find/:student/:tcc' => 'timeline#findByStudent'
        get 'timeline/find/teacher/:teacher/:year/:half/:tcc' => 'timeline#findByTeacher'
        get 'timeline/item/get/:id' => 'timeline#getItem'
        post 'timeline/item/send/:id' => 'timeline#sendFile'
        # deve ser utilizado em um cron
        get 'timeline/refresh' => 'timeline#refreshItems'

        # rotas da api para bancas
        post 'banks/new' => 'banks#new'
        get 'banks/all' => 'banks#all'
        get 'banks/get/:id' => 'banks#get'
        get 'banks/find/:timeline' => 'banks#find_by_timeline'
        put 'banks/edit/:id' => 'banks#edit'
        delete 'banks/delete/:timeline' => 'banks#delete'
        get 'banks/find/teacher/:teacher_id' => 'banks#findByTeacher'
        post 'banks/notes/:bank_id/:teacher_id' => 'banks#setNote'

        # rotas da api para os métodos de controle do angularJS
        get 'messages' => 'page#messages'
        post 'login' => 'page#login'
    end
end
