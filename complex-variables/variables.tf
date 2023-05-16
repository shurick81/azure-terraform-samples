variable "location" {
  type    = string
  default = "westeurope"
}

variable "internal_location" {
  type = string
  default = "cop-devtest-ase"
}

variable "stream" {
  type = map(string)
  default = {
    "dev"  = "stream01"
    "uat"  = "stream01"
    "qa"   = "stream01"
    "prod" = "stream00"
  }
}

variable "apptus_full_import_job_schedule" {
  type = map(string)
  default = {
    "dev"  = "0 0 0 29 Feb Sat"
    "uat"  = "0 0 7 * * *"
    "qa"   = "0 0 0 29 Feb Sat"
    "prod" = "0 0 0 29 Feb Sat"
  }
}

variable "azure_product_feed" {
  #type = map(object({
  #  containerName = string
  #  blobs = list(object({
  #    market = string
  #    locale = string
  #    blobName = string
  #  }))
  #}))
  default = {
    dev  = "test3456345"
    uat  = {
      containerName = "productfeedoutputexample"
      blobs = [
        {
          market = "SE"
          locale = "sv-SE"
          blobName = "productfeed-done-min-rse1.json"
        },
        {
          market = "FI"
          locale = "fi-FI"
          blobName = "productfeed-done-min-rfi1.json"
        },
        {
          market = "NO"
          locale = "nn-NO"
          blobName = "productfeed-done-min-rno1.json"
        },

        {
          market = "DK"
          locale = "da-DK"
          blobName = "productfeed-done-min-rde1.json"
        },
        {
          market = "UK"
          locale = "en-GB"
          blobName = "productfeed-done-min-ruk1.json"
        }
      ]
    }
    qa   = {
      containerName = "productfeedoutputexample"
      blobs = [
        {
          market = "SE"
          locale = "sv-SE"
          blobName = "productfeed-done-min-rse1.json"
        },
        {
          market = "FI"
          locale = "fi-FI"
          blobName = "productfeed-done-min-rfi1.json"
        },
        {
          market = "NO"
          locale = "nn-NO"
          blobName = "productfeed-done-min-rno1.json"
        },

        {
          market = "DK"
          locale = "da-DK"
          blobName = "productfeed-done-min-rde1.json"
        },
        {
          market = "UK"
          locale = "en-GB"
          blobName = "productfeed-done-min-ruk1.json"
        }
      ]
    }
    prod = {
      containerName = "productfeedoutputexample"
      blobs = [
        {
          market = "SE"
          locale = "sv-SE"
          blobName = "productfeed-done-min-rse1.json"
        },
        {
          market = "FI"
          locale = "fi-FI"
          blobName = "productfeed-done-min-rfi1.json"
        },
        {
          market = "NO"
          locale = "nn-NO"
          blobName = "productfeed-done-min-rno1.json"
        },

        {
          market = "DK"
          locale = "da-DK"
          blobName = "productfeed-done-min-rde1.json"
        },
        {
          market = "UK"
          locale = "en-GB"
          blobName = "productfeed-done-min-ruk1.json"
        }
      ]
    }
  }
}

