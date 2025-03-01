openapi: 3.0.0
info:
  title: Catalogs API
  version: 1.15.0
  description: |
    Open source clients:
    - [pc-client-slim](https://github.com/alex-ello/pc-client-slim) PHP based opensource client
security:
  - ApiKey: []
tags:
  - name: Ip
  - name: Catalogs
  - name: Cars
  - name: Groups
  - name: Parts
  - name: Groups tree
paths:
  /ip/:
    get:
      operationId: getIp
      tags:
        - Ip
      summary: Get user ip
      responses:
        '200':
          description: Id
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Ip'
  /catalogs/:
    get:
      operationId: getCatalogs
      tags:
        - Catalogs
      summary: Get available catalogs
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                title: array
                description: Catalog list
                type: array
                items:
                  $ref: '#/components/schemas/Catalog'
  '/catalogs/{catalogId}/models/':
    get:
      operationId: getModels
      tags:
        - Cars
      summary: Get catalog car models
      security:
        - ApiKey: []
      parameters:
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
      responses:
        '200':
          description: Model list
          content:
            application/json:
              schema:
                title: Array
                type: array
                items:
                  $ref: '#/components/schemas/Model'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          $ref: '#/components/responses/notFound'
  '/catalogs/{catalogId}/cars2/':
    get:
      operationId: getCars2
      tags:
        - Cars
      summary: Get car list of catalog
      description: Attention! Vehicle identifier may change over time.
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: modelId
          in: query
          description: Model id
          required: true
          schema:
            type: string
        - name: parameter
          in: query
          description: Filter cars by car parameter indexes (idx)
          required: false
          style: form
          explode: false
          schema:
            type: array
            items:
              type: array
              items:
                $ref: '#/components/schemas/CarParameterIdx'
        - name: page
          in: query
          required: false
          description: |-
            Page number (pagination). 
            Page number value must be greater than 0. Can output 25 cars on page
          schema:
            type: integer
            minimum: 0
      responses:
        '200':
          description: OK
          headers:
            X-Total-Count:
              schema:
                type: integer
          content:
            application/json:
              schema:
                title: array
                description: Car list
                type: array
                items:
                  $ref: '#/components/schemas/Car2'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
  '/catalogs/{catalogId}/cars2/{carId}':
    get:
      operationId: getCarsById2
      tags:
        - Cars
      summary: GET catalog car by id
      description: Attention! Vehicle identifier may change over time.
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: carId
          in: path
          description: Car id
          required: true
          schema:
            type: string
        - name: criteria
          in: query
          description: criteria
          required: false
          schema:
            type: string
      responses:
        '200':
          description: OK
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Car2'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
  '/catalogs/{catalogId}/cars-parameters/':
    get:
      operationId: getCarsParameters
      tags:
        - Cars
      summary: Get cars filters of selected catalog
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: modelId
          in: query
          description: Model id
          required: true
          schema:
            type: string
        - name: parameter
          in: query
          description: Filter parameters by idx
          required: false
          style: form
          explode: false
          example: 5651b9c4e2f55b54efe465354b3491e7,59e742688f05ca5ecc71a35cc2ff31c5
          schema:
            type: array
            items:
              type: array
              items:
                $ref: '#/components/schemas/CarParameterIdx'
      responses:
        '200':
          description: Filter
          headers:
            X-Cars-Count:
              description: Cars count filtered by parameters
              schema:
                type: integer
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/CarParameterInfo'
        '400':
          $ref: '#/components/responses/badRequest'
        '422':
          $ref: '#/components/responses/parameterMissing'
  '/catalogs/{catalogId}/groups2/':
    get:
      operationId: getGroups
      tags:
        - Groups
      summary: Get catalog groups
      description: >-
        With empty identifier shows main groups of catalog. It is necessary to
        select groups by ID until the "hasParts" value is true. The "hasParts"
        value indicates that the group contains spare parts. The list of spare
        parts can be received by the method parts2.
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: carId
          in: query
          schema:
            type: string
          required: true
        - name: groupId
          in: query
          required: false
          description: Group id
          schema:
            type: string
        - name: criteria
          in: query
          required: false
          description: >-
            Filters outcoming groups depending on criteria string. Criteria
            string can obtain from "car/info" method
          schema:
            type: string
      responses:
        '200':
          description: Catalog groups
          content:
            application/json:
              schema:
                title: Array
                type: array
                items:
                  $ref: '#/components/schemas/Group'
              example:
                - id: "MfCfmoAxMjI4fEE"
                  hasSubgroups: true
                  hasParts: false
                  name: "Accessories"
                  img: "//img.example.com/r/250x250/land_rover_2014_12/1228/A.png"
                  description: ""
                - id: "IzLwn5qAMTIyOHxB8J-agUEwMfCfmoJBMDEwMDV8TFQwMTIwPD4"
                  hasSubgroups: false
                  hasParts: true
                  name: "Auxiliary Lighting-Fog Lamps"
                  img: "//img.example.com/r/250x250/land_rover_2014_12/1228/lt0120().png"
                  description: ""
          links:
            getSubgroups:
              operationId: getGroups
              parameters:
                catalogId: '$request.path.catalogId'
                carId: '$request.query.carId'
                groupId: '$response.body#/0/id'
                criteria: '$request.query.criteria'
              description: >-
                If parameter `hasParts: false`
            getParts:
              operationId: getParts
              parameters:
                catalogId: '$request.path.catalogId'
                carId: '$request.query.carId'
                groupId: '$response.body#/0/id'
                criteria: '$request.query.criteria'
              description: >-
                If parameter `hasParts: true`

        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          $ref: '#/components/responses/notFound'
  /car/info:
    get:
      operationId: getCarInfo
      security:
        - ApiKey: []
      tags:
        - Cars
      summary: Get car info by VIN or FRAME
      description: You may specify VIN or FRAME number in query. Attention! Vehicle identifier may change over time.
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: q
          in: query
          description: >-
            Automatically detects type of input data and performs search of cars
            by VIN or FRAME number depending on input data
          schema:
            type: string
        - name: catalogs
          in: query
          description: List of comma-separated Catalog IDs for search by vin or frame in selected catalogs
          explode: false
          schema:
            type: string
            example: kia,bmw,chevrolet,hyundai

      responses:
        '200':
          description: Ok
          content:
            application/json:
              schema:
                title: Array
                type: array
                items:
                  $ref: '#/components/schemas/CarInfo'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
  '/catalogs/{catalogId}/parts2':
    get:
      operationId: getParts2
      tags:
        - Parts
      summary: Get catalog parts.
      description: >-
        Get catalog parts. In case you receive IDs of groups with the value
        "hasParts=false", you get error 400 (No details found with specified
        parameters).
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - $ref: '#/components/parameters/XRedirectTemplate'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: carId
          in: query
          description: Car id
          required: true
          schema:
            type: string
        - name: groupId
          in: query
          description: Group id
          required: true
          schema:
            type: string
        - name: criteria
          in: query
          description: Additional criteria string
          schema:
            type: string
      responses:
        '200':
          description: Parts list
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Parts'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          description: No details found with specified parameters
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  '/catalogs/{catalogId}/groups-suggest':
    get:
      operationId: getGroupsSuggest
      tags:
        - Groups
      summary: Get group suggest.
      description: Suggest parts with relative to group id
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: q
          in: query
          description: First letters of searching part
          required: true
          example: 'bat'
          schema:
            type: string
      responses:
        '200':
          description: Suggest list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Suggest'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          description: Search string is empty
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  '/catalogs/{catalogId}/groups-by-sid':
    get:
      deprecated: true
      operationId: getGroupsBySid
      tags:
        - Groups
      summary: Get groups by search id.
      description: Get groups by search id
      security:
        - ApiKey: []
      parameters:
        - $ref: '#/components/parameters/AcceptLanguage'
        - name: catalogId
          in: path
          description: Catalog id
          required: true
          schema:
            type: string
            default: bmw
        - name: sid
          in: query
          description: Search id from group suggest
          required: true
          example: '12345'
          schema:
            type: string
        - name: carId
          in: query
          description: Car id
          required: true
          schema:
            type: string
        - name: criteria
          in: query
          description: Additional criteria string
          schema:
            type: string
        - name: text
          in: query
          description: This field is the name of the part. After searching for groups by sid, we can sort the groups by text, where there may be a part with this name.
          schema:
            type: string
      responses:
        '200':
          description: Suggest list
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Group'
        '400':
          $ref: '#/components/responses/badRequest'
        '403':
          $ref: '#/components/responses/accessDeny'
        '404':
          description: Search string is empty
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  /example/prices:
    get:
      operationId: "getExamplePrices"
      summary: "Get prices of part"
      description: |
        This endpoint is a demonstration example showing how to retrieve information about prices and availability of parts by unique product code and brand. It is intended for developers and API architects as an illustration of potential functionality, not as a ready-to-use solution for production environments.
      tags:
        - Example
      parameters:
        - in: "query"
          required: true
          name: "code"
          schema:
            type: "string"
        - in: "query"
          name: "brand"
          required: true
          schema:
            type: "string"
      responses:
        200:
          description: ""
          content:
            application/json:
              schema:
                type: "array"
                items:
                  $ref: "#/components/schemas/ExamplePricesResponse"
        default:
          description: Any error 400 - 500
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  /catalogs/{catalogId}/groups-tree:
    get:
      operationId: "Get groups tree"
      description: "Get groups tree"
      tags:
        - Groups tree
      parameters:
        - in: "path"
          required: true
          name: "catalogId"
          schema:
            type: "string"
        - in: "query"
          name: "carId"
          schema:
            type: "string"
        - in: "query"
          name: "criteria"
          schema:
            type: "string"
        - in: "query"
          name: "cached"
          description: A flag that determines whether the general unfiltered group tree should be retrieved from the cache or filtered tree with increased latency should be retrieved.
          schema:
            type: "boolean"
      responses:
        200:
          description: ""
          content:
            application/json:
              schema:
                type: "array"
                items:
                  $ref: "#/components/schemas/GroupsTreeResponse"
        default:
          description: Any error 400 - 500
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
  /catalogs/{catalogId}/schemas:
    get:
      operationId: "Get schemas"
      description: "Get schemas that lead to detail pages."
      tags:
        - Groups tree
      parameters:
        - in: "query"
          required: true
          name: "carId"
          schema:
            type: "string"
        - in: "path"
          required: true
          name: "catalogId"
          schema:
            type: "string"
            example: "toyota"
        - in: "query"
          name: "branchId"
          description: Id for filter schemas by branch id. Branch id it is group id.
          schema:
            type: "string"
        - in: "query"
          name: "criteria"
          schema:
            type: "string"
        - in: "query"
          name: "page"
          description: The page number. One response can contain a maximum of 24 elements.
          schema:
            type: "integer"
            default: 0
            minimum: 0
        - in: "query"
          name: "partNameIds"
          description: Part name ids for filter schemas
          example: "56,85"
          schema:
            type: "string"
        - in: "query"
          name: "partName"
          description: Part name for filter schemas
          example: "Air filter"
          schema:
            type: "string"
      responses:
        200:
          description: ""
          content:
            application/json:
              schema:
                $ref: "#/components/schemas/SchemasResponse"
          headers:
            X-Total-Count:
              schema:
                type: integer
              description: The total number of items available for extraction.
        default:
          description: Any error 400 - 500
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
servers:
  - url: '/v1'
components:
  responses:
    accessDeny:
      description: Access deny
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    parameterMissing:
      description: Unprocessable Entity
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    notFound:
      description: Not Found
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
    badRequest:
      description: Bad Request
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/Error'
  securitySchemes:
    ApiKey:
      type: apiKey
      description: Authorization by ApiKey
      name: Authorization
      in: header
  schemas:
    Ip:
      properties:
        ip:
          description: ip value
          type: string
    CarParameterInfo:
      properties:
        key:
          type: string
        name:
          type: string
        values:
          type: array
          items:
            type: object
            properties:
              idx:
                $ref: '#/components/schemas/CarParameterIdx'
              value:
                type: string
        sortOrder:
          type: integer
          description: 'You can sort the parameters in the external interface in the sort order 
                from minimum to maximum. The smaller the sortOrder, the higher the priority of the parameter.'
    CarParameterIdx:
      description: Index of car parameter (idx)
      type: string
    Parts:
      description: Parts description
      required:
        - img
        - partGroups
      properties:
        img:
          description: URL of full-size parts group image
          type: string
        imgDescription:
          description: Parts group description
          type: string
        partGroups:
          description: Parts group list
          type: array
          items:
            $ref: '#/components/schemas/PartsGroup'
        positions:
          description: Positions of blocks with a number on image
          type: array
          items:
            description: Position of block with a part number on image
            type: object
            properties:
              number:
                description: Number on image
                type: string
              coordinates:
                description:
                  Coordinate data<br />
                  X - horizontal coordinate relative to the upper left of the full-size image, in pixels<br />
                  Y - vertical coordinate relative to the upper left of the full-size image, in pixels<br />
                  H - height of block with a part number on the full-size image, in pixels<br />
                  W - width of block with a part number on the full-size image, in pixels
                type: array
                items:
                  description: 'array (X, Y, H, W)'
                  type: number
                minItems: 4
                maxItems: 4
    PartsGroup:
      description: Parts group
      type: object
      required:
        - parts
      properties:
        name:
          description: Part name
          type: string
        number:
          description: Parts group number
          type: string
        positionNumber:
          description: Parts group position number on image
          type: string
        description:
          description: Parts group description. Installation notes, applicability. Description of the part or group of parts.
          type: string
        parts:
          description: Group detail list
          type: array
          items:
            $ref: '#/components/schemas/Part'
    Group:
      description: Group
      required:
        - id
        - name
      properties:
        id:
          description: Group id
          type: string
        parentId:
          description: Parent id. Can be `null` if there is no parent
          type: string
        hasSubgroups:
          description: Indicates that the group has subgroups
          type: boolean
        hasParts:
          description: Indicates that the group has parts
          type: boolean
        name:
          description: Group name
          type: string
        img:
          description: Group image
          type: string
        description:
          description: Group description
          type: string
    Car2:
      description: Car
      required:
        - id
        - catalogId
        - name
      properties:
        id:
          description: |-
            Is a car identifier in the Parts-Catalogs system; 
            this parameter is not constant and can change when updating catalogs
          type: string
        catalogId:
          description: Catalog id
          type: string
        name:
          description: Car name
          type: string
        description:
          description: Car description
          type: string
        modelId:
          description: Car model id
          type: string
          example: 'd3190764f126fabbf56bf3e36efbd56a'
        modelName:
          description: Car model name
          type: string
        modelImg:
          description: Model image URL
          type: string
        vin:
          description: Car vin
          type: string
        frame:
          description: Car frame
          type: string
        criteria:
          description: |-
            Criteria is a parameter, which contains info by VIN taken from the "car/info" method; 
            this parameter is used to filter groups and parts for a specified VIN
          type: string
        brand:
          description: Car brand
          type: string
        groupsTreeAvailable:
          description: Groups tree method availability flag
          type: boolean
        parameters:
          description: Car parameters
          type: array
          items:
            type: object
            properties:
              idx:
                type: string
                description: hash id of car param
              key:
                type: string
              name:
                type: string
              value:
                type: string
              sortOrder:
                type: integer
                description: 'You can sort the parameters in the external interface in the sort order 
                from minimum to maximum. The smaller the sortOrder, the higher the priority of the parameter.'
    CarFilterValues:
      title: Car filter
      description: The values of the specific complectation parameter
      properties:
        name:
          description: Parameter name
          type: object
          properties:
            id:
              description: Parameter id
              type: string
            key:
              description: Inner key of parameter
              type: string
            text:
              description: Parameter text
              type: string
        values:
          description: Parameter value
          type: array
          items:
            type: object
            properties:
              id:
                type: string
                description: Parameter value id
              text:
                type: string
                description: Parameter value text
    Model:
      title: Models
      description: Car model
      required:
        - id
        - name
      properties:
        id:
          description: Model id
          type: string
        name:
          description: Model name
          type: string
        img:
          description: Model image URL
          type: string
    Catalog:
      title: Catalog
      required:
        - id
        - name
        - modelsCount
      properties:
        id:
          description: Catalog id
          type: string
        name:
          description: Catalog name
          type: string
        modelsCount:
          type: integer
    Error:
      title: Error
      description: Error response to request
      required:
        - code
        - message
      properties:
        code:
          description: Response code
          type: integer
          format: int32
        errorCode:
          description: Error code
          type: string
        message:
          description: Text message
          type: string
    CarInfo:
      properties:
        title:
          type: string
        catalogId:
          description: Catalog id
          type: string
        brand:
          description: Car brand
          type: string
        modelId:
          description: Car model id
          type: string
          example: '5bb58a3cab059a189ef92be181380fd5'
        carId:
          description: Car id
          type: string
        criteria:
          description: 'Additional criterias to search in groups, subgroups and parts'
          type: string
        vin:
          description: Car vin
          type: string
        frame:
          description: Car frame
          type: string
        modelName:
          description: Car model name
          type: string
        description:
          description: Car description
          type: string
        groupsTreeAvailable:
          description: Groups tree method availability flag
          type: boolean
        optionCodes:
          description: Car option codes
          type: array
          items:
            properties:
              code:
                type: string
              description:
                type: string
        parameters:
          description: Car parameters
          type: array
          items:
            type: object
            properties:
              idx:
                type: string
                description: hash id of car param
              key:
                type: string
              name:
                type: string
              value:
                type: string
              sortOrder:
                type: integer
                description: 'You can sort the parameters in the external interface in the sort order 
                from minimum to maximum. The smaller the sortOrder, the higher the priority of the parameter.'
    Part:
      description: Part
      type: object
      properties:
        id:
          description: Part id
          type: string
        nameId:
          nullable: true
          description: Name id
          type: string
        name:
          description: Name
          type: string
        number:
          description: Part number
          type: string
        notice:
          type: string
          description: |-
            Short note.
            It can has url for go to sections in gui.
            To get url in this field, you must send header with template for your gui url.
        description:
          description: |-
            Part description. Installation notes, applicability. Replacements. Description and characteristics of the part.
            It can has url for go to sections in gui.
            To get url in this field, you must send header with template for your gui url.
          type: string
        positionNumber:
          description: Position number on image group
          type: string
        url:
          description: Search results URL
          type: string
    Suggest:
      description: suggest
      type: object
      properties:
        sid:
          description: search id
          type: string
          example: '12345'
        name:
          description: Name
          type: string
          example: 'battery'
    ExamplePricesResponse:
      properties:
        id:
          type: "string"
        title:
          type: "string"
        code:
          type: "string"
        brand:
          type: "string"
        price:
          type: "string"
        basketQty:
          type: "string"
        inStockQty:
          type: "string"
        rating:
          type: "string"
        delivery:
          type: "string"
        payload:
          type: "object"
          additionalProperties:
            type: "string"
    SchemasResponse:
      properties:
        group:
          nullable: true
          oneOf:
            - $ref: "#/components/schemas/Group"
        list:
          type: "array"
          items:
            $ref: "#/components/schemas/Schema"
    Schema:
      properties:
        groupId:
          nullable: false
          type: "string"
          example: "IzLwn5qAMDA08J-agTg0RTQyOULwn5SwMjI18J-QkjU4NfCfkIk4NEU0MjlC"
        img:
          nullable: true
          type: "string"
          example: "//img.parts-catalogs.com/toyota_2022_12/usa/84E429B.png"
        name:
          nullable: false
          type: "string"
          example: "ENGINE & TRANSMISSION ILLUST NO. 1 OF 7"
        description:
          nullable: true
          type: "string"
          example: ""
        partNames:
          type: "array"
          items:
            $ref: "#/components/schemas/PartName"
    PartName:
      properties:
        id:
          nullable: false
          type: "string"
        name:
          nullable: false
          type: "string"
    GroupsTreeResponse:
      properties:
        id:
          nullable: false
          type: "string"
        name:
          nullable: false
          type: "string"
        parentId:
          nullable: true
          type: "string"
        subGroups:
          nullable: false
          type: "array"
          items:
            $ref: "#/components/schemas/GroupsTree"
    GroupsTree:
      properties:
        id:
          nullable: false
          type: "string"
        name:
          nullable: false
          type: "string"
        parentId:
          nullable: true
          type: "string"
        subGroups:
          nullable: false
          type: "array"
          example: [ ]
  parameters:
    AcceptLanguage:
      name: Accept-Language
      in: header
      description: Language of return data
      schema:
        type: string
        default: en
        enum: [en, ru, de, bg, fr, es, he]
    XRedirectTemplate:
      name: x-redirect-template
      in: header
      description:  |-
        Template for your gui url.
        In template must be 2 templates separated by commas for go to group list and parts list.
        If vin is not used, then you do not need to pass criteria and vin to the template.
      schema:
        type: string
        example: parts <a href="#/parts?catalogId=%catalogId%&modelId=%modelId%&carId=%carId%&groupId=%groupId%&q=%vin%&criteria=%criteria%">%text%</a>, groups <a href="#/groups?catalogId=%catalogId%&modelId=%modelId%&carId=%carId%&groupsPath=%groupId%&q=%vin%&criteria=%criteria%">%text%</a>